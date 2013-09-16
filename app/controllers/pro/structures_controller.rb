# encoding: utf-8
class Pro::StructuresController < Pro::ProController
  before_filter :authenticate_pro_admin!, except: [:select, :new, :create, :get_feedbacks, :widget_ext]
  load_and_authorize_resource :structure, except: [:select, :edit, :new, :create, :get_feedbacks, :widget_ext]

  layout :get_layout

  respond_to :json

  def signature
  end

  def flyer
  end

  def widget
    @structure = Structure.find params[:id]
    respond_to do |format|
      format.html
    end
  end

  def widget_ext
    # TODO protect
    @structure = Structure.find params[:id]
    headers['Access-Control-Allow-Origin']  = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
    headers['Access-Control-Max-Age']       = "1728000"
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, X-CSRF-Token'
    respond_to do |format|
      format.json { render text: render_to_string(partial: 'pro/structures/widget', layout: false)}
    end
  end

  def recommend_friends
    @structure      = Structure.find params[:id]
    params[:emails] ||= ''
    regexp = Regexp.new(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/)
    emails = params[:emails].scan(regexp).uniq
    text = '<p>' + params[:text].gsub(/\r\n/, '</p><p>') + '</p>'
    emails.each do |email|
      InvitedTeacher.where(email: email, structure_id: @structure.id).first_or_create
      AdminMailer.delay.recommand_friends(@structure, text, email)
      AdminMailer.delay.recommand_friends(@structure, text, 'contact@coursavenue.com')
    end
    respond_to do |format|
      format.html { redirect_to coursavenue_recommendations_pro_structure_path(@structure), notice: (params[:emails].present? ? 'Vos amis ont bien été notifiés<br> Nous vous contacterons sous peu.': nil)}
    end
  end

  def get_feedbacks
    @structure      = Structure.find params[:id]
    params[:emails] ||= ''
    regexp = Regexp.new(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/)
    emails = params[:emails].scan(regexp).uniq
    text = '<p>' + params[:text].gsub(/\r\n/, '</p><p>') + '</p>'
    emails.each do |email|
      StudentMailer.delay.ask_for_feedbacks(@structure, text, email)
    end
    respond_to do |format|
      format.html { redirect_to params[:redirect_to] || recommendations_pro_structure_path(@structure), notice: (params[:emails].present? ? 'Vos élèves ont bien été notifiés.': nil)}
    end
  end

  def coursavenue_recommendations
  end

  def crop
    @structure = Structure.find params[:id]
  end

  def wizard
    @wizard = get_next_wizard
    @structure = Structure.find params[:id]
    respond_to do |format|
      if @wizard
        format.json { render json: { form: render_to_string(partial: @wizard.partial, layout: false, formats: [:html]), done: false }  }
      else
        format.json { render json: { done: true }  }
      end
    end
  end

  def dashboard
    @structure      = Structure.find params[:id]
    @wizard         = get_next_wizard
    commentable_ids = @structure.courses.collect(&:id)
    commentable_ids << @structure.id
    @comments       = @structure.comments
    @courses        = @structure.courses
    @medias         = @structure.medias
    @profile_percentage = 100
    @profile_percentage -= 20 if !@structure.profile_completed?
    @profile_percentage -= 20 if @structure.medias.empty?
    @profile_percentage -= 20 if @comments.empty?
    @profile_percentage -= 20 if @structure.courses.active.count == 0
  end

  def select
    structure_with_admin  = Structure.select(:id).joins(:admins)
    @structures           = Structure.where{id.not_in structure_with_admin}.order('name ASC').all
  end


  def activate
    @structure        = Structure.find params[:id]
    respond_to do |format|
      if @structure.activate!
        format.html { redirect_to pro_structures_path }
      else
        format.html { redirect_to pro_structures_path, alert: 'Les informations de la structure ne sont pas complètes.' }
      end
    end
  end

  def disable
    @structure        = Structure.find params[:id]
    respond_to do |format|
      if @structure.disable!
        format.html { redirect_to pro_structures_path }
      else
        format.html { redirect_to pro_structures_path, alert: 'Les informations de la structure ne sont pas complètes.' }
      end
    end
  end

  def index
    @structures = Structure.order('created_at ASC').all
  end

  def show
    @structure = Structure.find params[:id]
    @courses   = @structure.courses.order('name ASC')
  end

  def edit
    @structure = Structure.find(params[:id])
    @ratio     = 1
    @ratio     = @structure.ratio_from_original(:large)
    @admin     = @structure.admins.first || @structure.admins.build
  end

  def new
    session[:name]     = params[:name]
    session[:zip_code] = params[:zip_code]
    session[:email]    = params[:email]
    @structure  = Structure.new name: params[:name], zip_code: params[:zip_code], contact_email: params[:email]
    @structures = Structure.where{(image_updated_at != nil) & (comments_count != nil)}.order('comments_count DESC').limit(3)
  end

  def update
    @ratio     = 1
    @structure = Structure.find params[:id]
    deleted_image = false
    if params[:structure].delete(:delete_image) == '1'
      @structure.image.clear
      deleted_image = true
    end
    if params[:structure].delete(:delete_logo) == '1'
      @structure.logo.clear
      deleted_image = true
    end

    respond_to do |format|
      if @structure.update_attributes(params[:structure])
        @ratio = @structure.ratio_from_original(:large)
        if deleted_image
          format.html { redirect_to edit_pro_structure_path(@structure), notice: 'Vous pouvez maintenant télécharger une autre photo.' }
        else
          format.html { redirect_to pro_structure_path(@structure), notice: 'Vos informations ont bien été mises à jour.' }
        end
        format.js { render nothing: true }
        format.json { render json: {
                                image: { path: @structure.image.url(:normal)},
                                logo: {
                                        path: @structure.logo.url(:large),
                                        ratio: @ratio,
                                        crop_x: 0,
                                        crop_y: 0,
                                        crop_width: 200,
                                        crop_height: 200
                                      }
                                  }
                                }
      else
        format.html { render action: 'edit' }
      end
    end
  end


  def create
    # Prevents from duplicates
    s_name      = params[:structure][:name]
    s_zip_code  = params[:structure][:zip_code]
    @structure  = Structure.where{(name == s_name) & (zip_code == s_zip_code)}.first
    @structures = Structure.where{(image_updated_at != nil) & (comments_count != nil)}.order('comments_count DESC').limit(3)
    place_name = params[:structure][:location].delete :name
    params[:structure].delete :location
    if @structure.nil?
      @structure = Structure.new params[:structure]
    end
    respond_to do |format|
      if !@structure.new_record? or @structure.save
        @structure.create_place(place_name) unless @structure.places.any?
        session[:id] = @structure.id
        format.html { redirect_to new_pro_admin_structure_registration_path(@structure, subdomain: 'pro'), notice: 'Félicitation, votre profil est maintenant créé !<br>Dernière étape : créez vos identifiants.' }
      else
        format.html { render 'pro/structures/new' }
      end
    end
  end

  def destroy
    @structure = Structure.find params[:id]
    respond_to do |format|
      if @structure.destroy
        format.html { redirect_to pro_admins_path, notice: 'Structure supprimé' }
      else
        format.html { redirect_to pro_admins_path, alert: 'Oups...' }
      end
    end
  end

  private

  def get_next_wizard
    if params[:next] and session[:current_wizard_id] and session[:current_wizard_id] == Wizard.data.length
      return nil
    elsif params[:next] and session[:current_wizard_id] and session[:current_wizard_id] < Wizard.data.length
      session[:current_wizard_id] += 1
      return Wizard.find(session[:current_wizard_id])
    else
      Wizard.all.each do |wizard|
        unless wizard.completed?.call(@structure)
          session[:current_wizard_id] = wizard.id
          return wizard
        end
      end
      return nil
    end
  end

  def get_layout
    if action_name == 'new' or action_name == 'create'
      'empty'
    else
      'admin'
    end
  end
end
