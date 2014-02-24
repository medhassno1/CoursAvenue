# encoding: utf-8
class ::Pro::Structures::InvitedTeachersController < Pro::ProController
  before_action :authenticate_pro_admin!
  load_and_authorize_resource :structure, find_by: :slug

  def index
    @structure        = Structure.friendly.find params[:structure_id]
    @invited_teachers = @structure.invited_teachers
  end

  def new
  end

  def bulk_create
    params[:emails] ||= ''
    regexp = Regexp.new(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/)
    emails = params[:emails].scan(regexp).uniq
    text = '<p>' + params[:text].gsub(/\r\n/, '</p><p>') + '</p>' if params[:text].present?

    emails.each do |_email|
      invited_user = ::InvitedUser::Teacher.where(email: _email, referrer_id: @structure.id, referrer_type: 'Structure', email_text: text).first_or_create
      InvitedUserMailer.delay.recommand_friends(invited_user)
    end

    respond_to do |format|
      format.html { redirect_to new_pro_structure_invited_teacher_path(@structure), notice: (params[:emails].present? ? 'Les autres professeurs ont bien été notifiés.' : nil) }
    end
  end
end
