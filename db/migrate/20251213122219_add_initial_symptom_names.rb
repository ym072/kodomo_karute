class AddInitialSymptomNames < ActiveRecord::Migration[7.2]
  def up
    ["頭痛", "咳", "鼻水", "発疹", "嘔吐", "便"].each do |name|
      SymptomName.find_or_create_by!(name: name)
    end
  end

  def down
    SymptomName.where(name: ["頭痛","咳","鼻水","発疹","嘔吐","便"]).delete_all
  end
end
