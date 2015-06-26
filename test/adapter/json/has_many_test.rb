require 'test_helper'

module ActiveModel
  class Serializer
    class Adapter
      class Json
        class HasManyTestTest < Minitest::Test
          def setup
            @author = Author.new(id: 1, name: 'Steve K.')
            @post = Post.new(id: 42, title: 'New Post', body: 'Body')
            @first_comment = Comment.new(id: 1, body: 'ZOMG A COMMENT')
            @second_comment = Comment.new(id: 2, body: 'ZOMG ANOTHER COMMENT')
            @post.comments = [@first_comment, @second_comment]
            @post.author = @author
            @first_comment.post = @post
            @second_comment.post = @post
            @blog = Blog.new(id: 1, name: "My Blog!!")
            @post.blog = @blog
<<<<<<< HEAD

            @serializer = PostSerializer.new(@post)
            @adapter = ActiveModel::Serializer::Adapter::Json.new(@serializer)
=======
            @tag = Tag.new(id: 1, name: "#hash_tag")
            @post.tags = [@tag]
>>>>>>> cf77786... Fix #955
          end

          def test_has_many
            serializer = PostSerializer.new(@post)
            adapter = ActiveModel::Serializer::Adapter::Json.new(serializer)
            assert_equal([
                           {id: 1, body: 'ZOMG A COMMENT'},
                           {id: 2, body: 'ZOMG ANOTHER COMMENT'}
<<<<<<< HEAD
                         ], @adapter.serializable_hash[:comments])
=======
                         ], adapter.serializable_hash[:post][:comments])
          end

          def test_has_many_with_no_serializer
            serializer = PostWithTagsSerializer.new(@post)
            adapter = ActiveModel::Serializer::Adapter::Json.new(serializer)
            assert_equal({
              id: 42,
              tags: [
                {"attributes"=>{"id"=>1, "name"=>"#hash_tag"}}
              ]
<<<<<<< HEAD
            }, adapter.serializable_hash[:post_with_tags])
>>>>>>> cf77786... Fix #955
=======
            }.to_json, adapter.serializable_hash[:post_with_tags].to_json)
>>>>>>> 17d560e... Account for different handling of symbol keys in Rails 4.0
          end
        end
      end
    end
  end
end

