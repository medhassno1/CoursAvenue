class RedirectController < ApplicationController
  include SubjectHelper

  # GET pro.coursavenue.com/paris, etc.
  # Redirects all links like pro.coursavenue.com/paris to www. subdomain
  def structures_index
    if params[:subject_id].present?
      redirect_to search_page_url(params[:root_subject_id], params[:subject_id], params[:city_id], subdomain: 'www'), status: 301
    elsif params[:root_subject_id].present?
      redirect_to root_search_page_url(params[:root_subject_id], params[:city_id], subdomain: 'www'), status: 301
    else
      redirect_to root_search_page_without_subject_url(params[:city_id], subdomain: 'www'), status: 301
    end
  end

  def vertical_page
    @subject = Subject.fetch_by_id_or_slug params[:id]
    if @subject
      redirect_to root_search_page_path(@subject.root, 'paris'), status: 301
    else
      redirect_to vertical_pages_path, status: 301
    end
  end

  def vertical_page_city
    @subject = Subject.fetch_by_id_or_slug params[:subject_id]
    @city    = City.find params[:id]
    redirect_to root_search_page_path(@subject.root, @city), status: 301
  end

  def vertical_page_subject_city
    @subject = Subject.fetch_by_id_or_slug params[:subject_id]
    @city    = City.find params[:id]
    redirect_to root_search_page_path(@subject.root, @city), status: 301
  end

  def why_coursavenue
    redirect_to pages_what_is_it_url, status: 301
  end

  def blog
    redirect_to 'https://www.coursavenue.com/blog', status: 301
  end

  def structures_new
    redirect_to inscription_pro_structures_path(params_for_search), status: 301
  end

  def disciplines
    redirect_to subject_courses_path(params[:id]), status: 301
  end

  def place_show
    redirect_to structure_path(params[:id]), status: 301
  end

  def place_index
    redirect_to structures_path(params_for_search), status: 301
  end

  def subject_place_index
    redirect_to subject_structures_path(params[:subject_id], params_for_search), status: 301
  end

  def lieux
    redirect_to structures_path(params_for_search), status: 301
  end

  def lieux_show
    redirect_to structure_path(params[:id]), status: 301
  end

  def city
    redirect_to courses_path, status: 301
  end

  def city_subject
    redirect_to subject_courses_path(params[:subject_id]), status: 301
  end

  private
  def params_for_search
    params.delete(:action)
    params.delete(:controller)
    params
  end
end
