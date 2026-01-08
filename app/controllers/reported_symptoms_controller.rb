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
    @disease_record = @kid.disease_records.where(end_at: nil)
                                          .order(start_at: :desc)
                                          .first
  
    if @disease_record.nil?
      redirect_to kid_path(@kid), alert: "記録中の病気がありません。"
      return
    end

    @tab = params[:tab] || "today"

    @reported_symptoms = @disease_record.reported_symptoms
                                        .includes(:symptom_name)

    @first_symptom_dates =@reported_symptoms.where.not(symptom_name_id: nil)
                                            .group(:symptom_name_id)
                                            .minimum(:recorded_at)
                                      
    if @tab == "today"
      today = Time.zone.today

      @day_count =
        (today - @disease_record.start_at.to_date).to_i + 1

      @today_symptoms =
        @reported_symptoms.where(recorded_at: today.all_day)

      @latest_temperature =
        @today_symptoms
          .where.not(body_temperature: nil)
          .order(recorded_at: :desc)
          .first

      vomit_id   = SymptomName.find_by(name: "嘔吐")&.id
      diarrhea_id = SymptomName.find_by(name: "便")&.id

      @vomit_count =
        vomit_id ? @today_symptoms.where(symptom_name_id: vomit_id).count : 0

      @diarrhea_count =
        diarrhea_id ? @today_symptoms.where(symptom_name_id: diarrhea_id).count : 0

      @symptom_day_counts = {}

      @first_symptom_dates.each do |symptom_id, first_time|
        @symptom_day_counts[symptom_id] =
          (today - first_time.to_date).to_i + 1
      end

      @today_symptom_names =
        @today_symptoms
          .where.not(symptom_name_id: nil)
          .select(:symptom_name_id)
          .distinct
          .includes(:symptom_name)
    end

    if @tab == "all"
      @symptom_slots = {
        headache: "頭痛",
        cough: "咳",
        runny_nose: "鼻水",
        rash: "発疹",
        vomit: "嘔吐",
        stool: "便",
        temperature: "体温"
      }

      this_week_start = Time.zone.today.beginning_of_week(:monday)
      this_week_end   = this_week_start + 6.days

      last_week_start = this_week_start - 7.days
      last_week_end   = last_week_start + 6.days

      @weeks = {
        last: (last_week_start..last_week_end).to_a,
        this: (this_week_start..this_week_end).to_a
      }

      range_start = last_week_start.beginning_of_day
      range_end   = this_week_end.end_of_day

      records =
        @reported_symptoms.where(recorded_at: range_start..range_end)

      @matrix = {}

      @weeks.values.flatten.each do |date|
        @matrix[date] = {}
        @symptom_slots.keys.each do |key|
          @matrix[date][key] = false
        end
      end

      records.each do |rs|
        date = rs.recorded_at.to_date
  
        if rs.symptom_name
          slot_key =
            @symptom_slots.find { |_, name| name == rs.symptom_name.name }&.first
          @matrix[date][slot_key] = true if slot_key
        end
  
        if rs.body_temperature.present?
          @matrix[date][:temperature] = true
        end
      end

      @end_date = Time.zone.today
      @start_date = @disease_record.start_at.to_date

      @dates = (@start_date..@end_date).to_a

      @records_by_date =
        @reported_symptoms
          .where(recorded_at: @start_date.beginning_of_day..@end_date.end_of_day)
          .group_by { |r| r.recorded_at.to_date }

      @chart_data = {
        labels: @dates.map { |d| d.strftime("%m/%d") },
        temperature: [],
        vomit: [],
        stool: []
      }

      @dates.each do |date|
        daily_records = @records_by_date.fetch(date, [])

        temp =
          daily_records
            .select { |r| r.body_temperature.present? }
            .max_by(&:recorded_at)
            &.body_temperature

        vomit_count =
          daily_records.count { |r| r.symptom_name&.name == "嘔吐" }

        stool_count =
          daily_records.count { |r| r.symptom_name&.name == "便" }

        @chart_data[:temperature] << temp
        @chart_data[:vomit] << vomit_count
        @chart_data[:stool] << stool_count
      end
    end
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
