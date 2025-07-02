class CommentsController < ApplicationController
  before_action :set_product
  before_action :set_comment, only: [ :edit, :update, :destroy ]
  before_action :authorize_comment, only: [ :edit, :update, :destroy ]


  def edit
    render turbo_stream: turbo_stream.replace("comment_form", partial: "comments/form", locals: { comment: @comment, product: @product })
  end
  def create
    @comment = @product.comments.build(comment_params.merge(user: current_user))
    authorize @comment
    if @comment.save
      render turbo_stream: turbo_stream.prepend("comments_list", partial: "comments/comment", locals: { comment: @comment })
    else
      render turbo_stream: turbo_stream.replace("comment_form", partial: "comments/form", locals: { comment: @comment, product: @product }
      )
    end
  end




  def update
    if @comment.update(comment_params)
      render turbo_stream: [
        turbo_stream.replace("comment_#{@comment.id}", partial: "comments/comment", locals: { comment: @comment }),
        turbo_stream.replace("comment_form", partial: "comments/form", locals: { comment: @product.comments.build, product: @product })
      ]
    else
      render turbo_stream: turbo_stream.replace(
      "comment_form",
      partial: "comments/form",
      locals: { comment: @comment, product: @product }
      )

    end
  end


  def destroy
    @comment.destroy
    render turbo_stream: turbo_stream.remove("comment_#{@comment.id}")
  end




  private

  def set_product
    @product = Product.find(params[:product_id])
  end
  def set_comment
    @comment = @product.comments.find(params[:id])
  end
  def comment_params
    params.require(:comment).permit(:content)
  end
  def authorize_comment
    authorize @comment
  end
end
