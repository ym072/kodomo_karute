class KidsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_kid, only: %i[select edit update destroy]

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

  def edit
  end

  def update
    if @kid.update(kid_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to kids_path, notice: "更新しました。" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @kid.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to kids_path, notice: "削除しました。" }
    end
  end

  private

  def set_kid
    @kid = current_user.kids.find(params[:id])
  end

  def kid_params
    params.require(:kid).permit(:name, :birthday, :icon)
  end
end
