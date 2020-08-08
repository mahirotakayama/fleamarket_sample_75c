class ItemsController < ApplicationController
  before_action :category_parent_array, only: [:new, :create, :edit, :update]
  before_action :check_item_details, only: [:post_done]

  def index
    @item = Item.all
  end

  def new
    @item = Item.new
    @parents = Category.all.order("id ASC").limit(13)
    @item.item_images.build
    @item.build_shipping
    @item.build_brand
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to post_done_item_path
    else
      redirect_to root_path
    end
  end

  def post_done
    @item = Item.all
  end

  def show
  end
  
  def edit
  end

  def update
    if item_params[:images_attributes].nil?
      flash.now[:alert] = '更新できませんでした【画像を1枚以上入れてください】'
      render :edit
    else
      exit_ids = []
      item_params[:images_attributes].each do |a,b|
        exit_ids << item_params[images_attributes].dig(:"#{a}", :id).to_i
      end
      ids = Image.where(item_id: params[:id]).map{|image| image.id}
      exit_ids_uniq = exit_ids.exit_ids_uniq
      delete__db = ids - exit_ids_uniq
      Image.where(id:delete__db).destroy_all
      @item.touch
    end
  end

  def search_child
    respond_to do |format|
      format.html
      format.json do
        @children = Category.find(params[:parent_id]).children
      end
    end
  end

  def search_grandchild
    respond_to do |format|
      format.html
      format.json do
        @grandchildren = Category.find(params[:child_id]).children
      end
    end
  end

  def purchase
  end

  private

  def item_params
    params.require(:item).permit(:name, :text, :category_id, :price, :condition, :fee_burden, :prefecture, :handling_time, item_images_attributes: [:image_url])
  end

  def category_parent_array
    @category_parent_array = Category.where(ancestry: nil).each do |parent|
    end
  end
  
  def check_item_details
    @item = Item.all
  end
end
