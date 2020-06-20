class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  scope :search_by_keyword, -> (keyword) {
    where("microposts.content LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
  }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
    validates :image,   content_type: { in: %w[image/jpeg image/png],
                                      message: "jpag もしくはpngの拡張子のデータをアップロードしてください" },
                      size:         { less_than: 5.megabytes,
                                      message: "ファイルサイズは5MBまでです" }
  # 表示用のりサイズ済み画像を返す
  def display_image
    image.variant({resize:"300x300^",crop:"300x300+0+0",gravity: :center})
  end  
  
  
  
end