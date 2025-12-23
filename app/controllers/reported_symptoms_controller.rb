class ReportedSymptomsController < ApplicationController
  before_action :set_kid
  before_action :set_disease_record, only: [:new, :create]

  def new
    if @disease_record.present?
      @show_start_popup = false
      @reported_symptom = @disease_record.reported_symptoms.new
    else
      @show_start_popup = true
      @reported_symptom = nil
    end
  end

  def start_record
    @disease_record = @kid.disease_records.find_by(end_at: nil)

    if @disease_record.present?
      redirect_to new_kid_reported_symptom_path(@kid), notice: "記録中です。"
    else
      @disease_record = @kid.disease_records.create!(start_at: Time.current)
      redirect_to new_kid_reported_symptom_path(@kid), notice: "記録をスタートしました。"
    end
  end

  def create
    unless @disease_record
      redirect_to new_kid_reported_symptom_path(@kid), alert: "記録をスタートしてください。"
      return
    end
  
    commit_type = params[:commit_type]
  
    case commit_type
    when "disease_name"
      @disease_record.update!(
        name: params[:reported_symptom][:disease_name]
      )
      redirect_to new_kid_reported_symptom_path(@kid), notice: "病名を記録しました"
      return
    end
  
    @reported_symptom = @disease_record.reported_symptoms.new(reported_symptom_params)
    @reported_symptom.recorded_at = Time.current
  
    if @reported_symptom.save
      redirect_to new_kid_reported_symptom_path(@kid), notice: "症状を記録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def summary
    @kid = Kid.find(params[:kid_id])
    @disease_record = @kid.disease_records.order(start_at: :desc, created_at: :desc).first
  
    if @disease_record.nil?
      redirect_to kid_path(@kid), alert: "記録中の病気がありません。"
      return
    end
  
    @reported_symptoms = @disease_record.reported_symptoms.includes(:symptom_name)
    @symptoms_by_date = @reported_symptoms.group_by { |rs| rs.created_at.to_date }
    @symptoms_by_date = @symptoms_by_date.sort.to_h
  end

  private

  def set_kid
    @kid = current_user.kids.find(params[:kid_id])
  end

  def set_disease_record
    @disease_record = @kid.disease_records.find_by(end_at: nil)
  end

  def reported_symptom_params
    params.require(:reported_symptom).permit(:symptom_name_id, :recorded_at, :memo, :body_temperature)
  end

  def disease_name_param
    params.dig(:reported_symptom, :disease_name)
  end
end
