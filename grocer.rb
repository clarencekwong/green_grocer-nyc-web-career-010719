def consolidate_cart(cart)
  # code here
  cart_list = {}
  cart.each do |cart_items|
    cart_items.each do |product, value|
      unless cart_list[product]
        cart_list[product] = value
        cart_list[product][:count] = 0
      end
      cart_list[product][:count] += 1
    end
  end
  cart_list
end

def apply_coupons(cart, coupons)
  # code here
  coupon_list = {}
  coupons.each do |coupon_code|
    cart.each do |product, values|
      if product == coupon_code[:item] && values[:count] >= coupon_code[:num]
        if coupon_list["#{coupon_code[:item]} W/COUPON"]
          coupon_list["#{coupon_code[:item]} W/COUPON"][:count] += 1
        else
          coupon_text = coupon_code[:item] + " W/COUPON"
          coupon_list[coupon_text] = { :price => coupon_code[:cost],
                                       :count => 1,
                                       :clearance => values[:clearance] }
        end
        values[:count] = values[:count] - coupon_code[:num]
      end
    end
  end
  cart.merge(coupon_list)
end

def apply_clearance(cart)
  # code here
  cart.each do |product, values|
    if values[:clearance]
      new_price = values[:price] * 0.80
      values[:price] = new_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  start_cart = consolidate_cart(cart)
  coupon_applied_cart = apply_coupons(start_cart, coupons)
  total_cart = apply_clearance(coupon_applied_cart)
  total = 0
  total_cart.each do |product, values|
    total += values[:price] * values[:count]
  end
  if total > 100
    total = total * 0.90
  end
  total.round(2)
end
