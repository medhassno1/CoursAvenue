# encoding: utf-8
class Pro::Structures::CommentsController < InheritedResources::Base#Pro::ProController
  before_action :authenticate_pro_admin!
  layout 'admin'

  def index
    @structure = Structure.find params[:structure_id]
    unless can? :read, @structure
      redirect_to pro_root_path, alert: "Vous n'êtes pas autorisé à voir cette page."
    end
    @comments                      = @structure.comments.accepted
    @pending_comments              = @structure.comments.pending
    @waiting_for_deletion_comments = @structure.comments.waiting_for_deletion
  end

  def accept
    @structure = Structure.find params[:structure_id]
    @comment   = @structure.comments.find params[:id]
    @comment.accept!
    redirect_to pro_structure_comments_path(@structure), notice: "L'avis à bien été accepté"
  end

  def decline
    @structure = Structure.find params[:structure_id]
    @comment   = @structure.comments.find params[:id]
    @comment.decline!
    redirect_to pro_structure_comments_path(@structure), notice: "L'avis à bien été refusé"
  end

  def ask_for_deletion
    @structure = Structure.find params[:structure_id]
    @comment   = @structure.comments.find params[:id]
    @comment.ask_for_deletion!(params[:deletion_reason])
    redirect_to pro_structure_comments_path(@structure), notice: "L'avis est en attente de suppression"
  end
end
