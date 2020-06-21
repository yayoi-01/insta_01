class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes, dependent: :destroy
  has_many :iine_users, through: :likes, source: :user
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
    image.variant({resize:"250x250^",crop:"250x250+0+0",gravity: :center})
  end  
  
    # マイクロポストをいいねする
  def iine(user)
    likes.create(user_id: user.id)
  end

  # マイクロポストのいいねを解除する（ネーミングセンスに対するクレームは受け付けません）
  def uniine(user)
    likes.find_by(user_id: user.id).destroy
  end
 
  # 現在のユーザーがいいねしてたらtrueを返す
  def iine?(user)
    iine_users.include?(user)
  end
  
end