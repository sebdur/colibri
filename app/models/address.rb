require 'csv'

class Address < ApplicationRecord
  belongs_to :payment

  def self.regions
    regions = File.join Rails.root, "lib/regions.csv"
    array_regions = []
    CSV.foreach(regions) do |row|
      array_regions << row
    end
    return array_regions
  end

  def self.communes
    communes = File.join Rails.root, "lib/communes.csv"
    array_communes = []
    CSV.foreach(communes) do |row|
      array_communes << row
    end
    return array_communes
  end
end
