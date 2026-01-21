class ChangeActiveStorageAttachmentsRecordIdToUuid < ActiveRecord::Migration[7.2]
  def up
    execute "TRUNCATE TABLE active_storage_attachments RESTART IDENTITY CASCADE;"
    
    remove_index :active_storage_attachments, name: "index_active_storage_attachments_uniqueness"
    
    change_column_null :active_storage_attachments, :record_id, true
    
    execute <<~SQL
      ALTER TABLE active_storage_attachments
      ALTER COLUMN record_id TYPE uuid
      USING NULL;
    SQL

    change_column_null :active_storage_attachments, :record_id, false

    add_index :active_storage_attachments,
              [:record_type, :record_id, :name, :blob_id],
              name: "index_active_storage_attachments_uniqueness",
              unique: true
  end

  def down
    remove_index :active_storage_attachments, name: "index_active_storage_attachments_uniqueness"

    change_column_null :active_storage_attachments, :record_id, true

    execute <<~SQL
      ALTER TABLE active_storage_attachments
      ALTER COLUMN record_id TYPE bigint
      USING NULL;
    SQL

    change_column_null :active_storage_attachments, :record_id, false

    add_index :active_storage_attachments,
              [:record_type, :record_id, :name, :blob_id],
              name: "index_active_storage_attachments_uniqueness",
              unique: true
  end
end
