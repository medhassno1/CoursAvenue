# encoding: utf-8
class Pro::Structures::StudentsController < Pro::ProController
  before_action      :authenticate_pro_admin!
  load_and_authorize_resource :structure

  def index
  end

  def destroy
    @structure = Structure.find params[:structure_id]
    @student   = @structure.students.find params[:id]
    respond_to do |format|
      if @student.destroy
        format.html { redirect_to pro_structure_students_path(@structure), notice: 'Élève supprimé'}
      else
        format.html { redirect_to pro_structure_students_path(@structure), alert: "Une erreur s'est produite"}
      end
    end
  end
end
