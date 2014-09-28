def create_tmp_model(_columns = {}, &_block)
  time = Time.now.to_f.to_s.gsub('.', '_')
  _model_name = "TmpClass#{time}"
  _table_name = "tmp_class#{time}s"
  # if ActiveRecord::Base.connection.table_exists? _table_name
  #   ActiveRecord::Migration.drop_table _table_name
  # end
  begin
    Object.send :remove_const, _model_name
  rescue NameError
  end

  ActiveRecord::Migration.create_table _table_name do |t|
    _columns.each do |name, type|
      t.column name, type
    end
  end
  Object.class_eval <<-EOS
    class #{_model_name} < ActiveRecord::Base
      self.table_name = '#{_table_name}'
    end
  EOS
  klass = Object.const_get _model_name
  klass.class_exec(&_block) unless _block.nil?
  klass
end
