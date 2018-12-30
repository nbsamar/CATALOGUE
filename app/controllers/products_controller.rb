class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
    2.times {@product.tags.build}
  end

  def create
    unless params[:product][:tags_attributes].to_unsafe_h.any? {|key, value| value['name'].blank?}
      product = Product.create!(params[:product].permit(:name, :price))
      params[:product][:tags_attributes].each do |tag|
        check_tag = Tag.find_by(name: tag[1]["name"])
        if check_tag.blank?
          new_tag = Tag.create!(name: tag[1]["name"])
          ProductTag.create!(tag_id: new_tag.id, product_id: product.id)
        else
          ProductTag.where(tag_id: check_tag.id, product_id: product.id).first_or_initialize.save!
        end
      end
      redirect_to products_path
      flash[:success] = 'Product Added'
    else
      redirect_to new_product_path
      flash[:error] = 'Enter at least 2 tags'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    product = Product.find(params[:id])
    product_attr = params[:product].permit(:name, :price)
    product.update(product_attr)
    params[:product][:tags_attributes].each do |tag|
      if tag[1]['_destroy'] == '1'
        ProductTag.where(tag_id: tag[1]['id'], product_id: product.id).delete_all
        next
      end
      check_tag = Tag.find_by(name: tag[1]["name"])
      if check_tag.blank?
        new_tag = Tag.create!(name: tag[1]["name"])
        ProductTag.create!(tag_id: new_tag.id, product_id: product.id)
      else
        ProductTag.where(tag_id: tag[1]['id'], product_id: product.id).delete_all
        ProductTag.where(tag_id: check_tag.id, product_id: product.id).first_or_initialize.save!
      end
    end
    redirect_to products_path
    flash[:success] = 'Product Updated'
  end

  def destroy
    Product.find(params[:id]).destroy
    redirect_to products_path
    flash[:info] = 'Product Destroyed'
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, tags_attributes: [:id, :name, :_destroy])
  end
end
