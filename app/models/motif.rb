class Motif < ApplicationRecord
  SHARED_ATTRIBUTES_WITH_RDV_SOLIDARITES = [
    :name, :deleted_at, :location_type, :name, :reservable_online, :rdv_solidarites_service_id, :category, :collectif,
    :follow_up
  ].freeze
  CATEGORIES_ENUM = {
    rsa_orientation: 0,
    rsa_accompagnement: 1,
    rsa_orientation_on_phone_platform: 2,
    rsa_cer_signature: 3,
    rsa_insertion_offer: 4,
    rsa_follow_up: 5,
    rsa_accompagnement_social: 6,
    rsa_accompagnement_sociopro: 7,
    rsa_main_tendue: 8,
    rsa_atelier_collectif_mandatory: 9
  }.freeze

  enum location_type: { public_office: 0, phone: 1, home: 2 }
  enum category: CATEGORIES_ENUM

  belongs_to :organisation
  has_many :rdvs, dependent: :nullify

  validates :rdv_solidarites_motif_id, uniqueness: true, presence: true
  validates :name, :location_type, presence: true

  def presential?
    location_type == "public_office"
  end

  def by_phone?
    location_type == "phone"
  end
end
