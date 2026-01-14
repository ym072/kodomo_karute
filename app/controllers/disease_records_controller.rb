class DiseaseRecordsController < ApplicationController
  before_action :set_kid
  before_action :set_disease_record, only: [ :end_form, :end_update ]

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
        format.html { redirect_to kid_path(@kid) }
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
    records = @kid.disease_records.where.not(end_at: nil)

    # 病名検索
    if params[:disease_name].present?
      records = records.where("name LIKE ?", "%#{params[:disease_name]}%")
    end

    # 期間検索
    if params[:from].present?
      records = records.where("start_at >= ?", params[:from])
    end

    if params[:to].present?
      records = records.where("end_at <= ?", params[:to])
    end

    # 症状検索
    if params[:symptom_name_id].present?
      records = records.joins(:reported_symptoms)
                       .where(reported_symptoms: { symptom_name_id: params[:symptom_name_id] })
                       .distinct
    end

    @disease_records =
      records
        .includes(reported_symptoms: :symptom_name)  # ← 追加（症状表示のN+1回避）
        .order(end_at: :desc)
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
