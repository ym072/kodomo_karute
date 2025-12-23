class DiseaseRecordsController < ApplicationController
  before_action :set_kid
  before_action :set_disease_record, only: [:end_form, :end_update]

  def new
    @disease_record = @kid.disease_records.new
  end

  def create
    @disease_record = @kid.disease_records.build(disease_record_params)
    if @disease_record.save
        redirect_to kid_path(@kid), notice: "記録スタート"
    else
        render :new, status: :unprocessable_entity
    end
  end

  def end_form
  end

  def end_update
    if @disease_record.update(end_at: Time.current)
      respond_to do |format|
        format.html { redirect_to kid_path(@kid)}
        format.js
      end
    else
      respond_to do |format|
        format.html { render :end_form, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def index
    @disease_records = @kid.disease_records.where.not(end_at: nil).order(end_at: :desc)
  end

  private

  def set_kid
    @kid = current_user.kids.find(params[:kid_id])
  end

  def set_disease_record
    @disease_record = @kid.disease_records.find(params[:id])
  end

  def disease_record_params
    params.require(:disease_record).permit(:name, :start_at, :end_at)
  end
end
