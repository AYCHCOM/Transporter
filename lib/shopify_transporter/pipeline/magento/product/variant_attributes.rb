# frozen_string_literal: true
require 'shopify_transporter/pipeline/stage'
require 'shopify_transporter/shopify'

module ShopifyTransporter
  module Pipeline
    module Magento
      module Product
        class VariantAttributes < Pipeline::Stage
          def convert(hash, record)
            # accumulator = VariantAttributesAccumulator.new(record)
            # accumulator.accumulate(hash)
            record # no op
          end

          class VariantAttributesAccumulator < Shopify::AttributesAccumulator
            def accumulate(current_product)
              return @output unless input_applies?(current_product)
              @output['variants'] ||= []
              @output['variants'] << { 'product_id' => current_product['product_id'] }
              @output
            end

            private

            def input_applies?(current_product)
              current_product['type'] == 'simple'
            end
          end
        end
      end
    end
  end
end
