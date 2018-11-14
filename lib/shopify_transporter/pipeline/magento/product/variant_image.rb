# frozen_string_literal: true
require 'shopify_transporter/pipeline/stage'
require 'shopify_transporter/shopify'
require 'pry'

module ShopifyTransporter
  module Pipeline
    module Magento
      module Product
        class VariantImage < Pipeline::Stage
          def convert(hash, record)
            return record unless hash['images'].present? && hash['parent_id'].present?

            variants = case record['variants']
            when nil
              []
            when Array
              record['variants']
            when Hash
              [record['variants']]
            end

            parent_images = case record['images']
            when nil
              []
            when Array
              record['images']
            when Hash
              [record['images']]
            end

            record.merge(
              {
                images: parent_images + [variant_image(hash)],
                variants: variants.map { |variant| with_image(hash, variant) },
              }.deep_stringify_keys
            )
          end

          private

          def with_image(input, variant)
            return variant unless input['product_id'] == variant['product_id']
            variant.merge('variant_image' => variant_image(input))
          end

          def variant_image(x)
            { 'src' => variant_image_url(x) }
          end

          def variant_image_url(input)
            return input['images']['url'] if input['images'].is_a?(Hash)
            input['images'].sort_by { |image| image['position'] }.first['url']
          end
        end
      end
    end
  end
end
