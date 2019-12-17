# frozen_string_literal: true

module ResponseLoader
  # `key` should match the file name minus the extension.
  # e.g. `list_mailboxes` would correspond to the file at
  # `spec/support/responses/list_mailboxes.json`.
  def self.load_json(key)
    file = File.join(response_dir, "#{key}.json")
    File.read(file)
  end

  def self.response_dir
    File.join(File.dirname(__FILE__), 'responses')
  end
  private_class_method :response_dir
end
