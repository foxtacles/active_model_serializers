module ActiveModel
  class Serializer
    class ArraySerializer
      Error = Class.new(StandardError)
      include Enumerable
      delegate :each, to: :@objects

      attr_reader :meta, :meta_key, :objects

      def initialize(objects, options = {})
        options.merge!(root: nil)

        @objects = objects.map do |object|
          serializer_class = options.fetch(
            :serializer,
            ActiveModel::Serializer.serializer_for(object)
          )

          if serializer_class.nil?
            fail Error, "No serializer found for object: #{object.inspect}"
          else
            serializer_class.new(object, options.except(:serializer))
          end
        end
        @meta     = options[:meta]
        @meta_key = options[:meta_key]
      end

      def json_key
        @objects.first.json_key if @objects.first
      end

      def root=(root)
        @objects.first.root = root if @objects.first
      end
    end
  end
end
