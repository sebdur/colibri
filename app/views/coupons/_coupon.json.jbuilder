json.extract! coupon, :id, :code, :description, :enabled, :created_at, :updated_at
json.url coupon_url(coupon, format: :json)
