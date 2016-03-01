require 'test_helper'

module ActiveModel
  class Serializer
    class Adapter
      class JsonApi
        class HasManyTest < Minitest::Test
          def setup
            ActionController::Base.cache_store.clear
            @author = Author.new(id: 1, name: 'Steve K.')
            @author.posts = []
            @author.bio = nil
            @post = Post.new(id: 1, title: 'New Post', body: 'Body')
            @post_without_comments = Post.new(id: 2, title: 'Second Post', body: 'Second')
            @first_comment = Comment.new(id: 1, body: 'ZOMG A COMMENT')
            @first_comment.author = nil
            @second_comment = Comment.new(id: 2, body: 'ZOMG ANOTHER COMMENT')
            @second_comment.author = nil
            @post.comments = [@first_comment, @second_comment]
            @post_without_comments.comments = []
            @first_comment.post = @post
            @second_comment.post = @post
            @post.author = @author
            @post_without_comments.author = nil
            @blog = Blog.new(id: 1, name: "My Blog!!")
            @blog.writer = @author
            @blog.articles = [@post]
            @post.blog = @blog
            @post_without_comments.blog = nil
<<<<<<< HEAD

=======
            @tag = Tag.new(id: 1, name: "#hash_tag")
            @post.tags = [@tag]
>>>>>>> cf77786... Fix #955
            @serializer = PostSerializer.new(@post)
            @adapter = ActiveModel::Serializer::Adapter::JsonApi.new(@serializer)
          end

          def test_includes_comment_ids
            expected = { linkage: [ { type: "comments", id: "1" }, { type: "comments", id: "2" } ] }

            assert_equal(expected, @adapter.serializable_hash[:data][:links][:comments])
          end

          def test_includes_linked_comments
            @adapter = ActiveModel::Serializer::Adapter::JsonApi.new(@serializer, include: 'comments')
            expected = [{
              id: "1",
              type: "comments",
              body: 'ZOMG A COMMENT',
              links: {
                post: { linkage: { type: "posts", id: "1" } },
                author: { linkage: nil }
              }
            }, {
              id: "2",
              type: "comments",
              body: 'ZOMG ANOTHER COMMENT',
              links: {
                post: { linkage: { type: "posts", id: "1" } },
                author: { linkage: nil }
              }
            }]
            assert_equal expected, @adapter.serializable_hash[:included]
          end

          def test_limit_fields_of_linked_comments
            @adapter = ActiveModel::Serializer::Adapter::JsonApi.new(@serializer, include: 'comments', fields: {comment: [:id]})
            expected = [{
              id: "1",
              type: "comments",
              links: {
                post: { linkage: { type: "posts", id: "1" } },
                author: { linkage: nil }
              }
            }, {
              id: "2",
              type: "comments",
              links: {
                post: { linkage: { type: "posts", id: "1" } },
                author: { linkage: nil }
              }
            }]
            assert_equal expected, @adapter.serializable_hash[:included]
          end

          def test_no_include_linked_if_comments_is_empty
            serializer = PostSerializer.new(@post_without_comments)
            adapter = ActiveModel::Serializer::Adapter::JsonApi.new(serializer)

            assert_nil adapter.serializable_hash[:linked]
          end

          def test_include_type_for_association_when_different_than_name
            serializer = BlogSerializer.new(@blog)
            adapter = ActiveModel::Serializer::Adapter::JsonApi.new(serializer)
<<<<<<< HEAD
            actual = adapter.serializable_hash[:data][:links][:articles]
=======
            actual = adapter.serializable_hash[:data][:relationships][:articles]

>>>>>>> cf77786... Fix #955
            expected = {
              linkage: [{
                type: "posts",
                id: "1"
              }]
            }
            assert_equal expected, actual
          end
<<<<<<< HEAD
=======

          def test_has_many_with_no_serializer
            serializer = PostWithTagsSerializer.new(@post)
            adapter = ActiveModel::Serializer::Adapter::JsonApi.new(serializer)

            assert_equal({
              data: {
                id: "1",
                type: "posts",
                relationships: {
                  tags: {:data=>nil}
                }
              }
            }, adapter.serializable_hash)
          end
>>>>>>> cf77786... Fix #955
        end
      end
    end
  end
end
