require 'file_utilities'
class Test
  extend FileUtilities

  def self.test_with_mit_bih
    indexes = get_qrs_indexes_from_db("qrs_attr.out")
    save_each_line("mit_bih_val_to_test.txt", indexes)
  end

  test_with_mit_bih
end