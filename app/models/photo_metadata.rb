class PhotoMetadata
  include Mongoid::Document

  field :up, as: :uploader, type: String
  field :ct, as: :content_type, type: String
  field :fn, as: :store_filename, type: String
  field :ut, as: :upload_time, type: Time
  field :an, as: :animated, type: Boolean
  field :hsh, as: :md5_hash, type: String
  field :si, as: :sizes, type: Hash, default: {}

  def serializable_hash(options)
    original_hash = super(options)
    Hash[original_hash.map {|k, v|
           [self.aliased_fields.invert[k] || k , as_str(v)]
         }]
  end

  def self.exist?(id)
    where(id: id).exists?
  end

end