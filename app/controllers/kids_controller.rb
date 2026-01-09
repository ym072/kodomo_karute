class KidsController < ApplicationController
  before_action :authenticate_user!

  def new
    @kid = Kid.new
  end

  def create
    @kid = current_user.kids.build(kid_params)
    if @kid.save
      redirect_to kids_path, notice: "登録しました."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @kids = current_user.kids
  end

  def select
    @kid = current_user.kids.find(params[:id])
    session[:current_kid_id] = @kid.id
    latest_record = @kid.disease_records.order(:start_at).last

    if latest_record.nil? || latest_record.end_at.present?
      redirect_to new_kid_reported_symptom_path(@kid, new_record: true)
    else
      redirect_to new_kid_reported_symptom_path(@kid, disease_record_id: latest_record.id)
    end
  end

  def show
    @kid = current_user.kids.find(params[:id])
    @disease_records = @kid.disease_records.order(start_at: :desc)
  end

  private

  def kid_params
    params.require(:kid).permit(:name, :birthday, :icon)
  end
end
