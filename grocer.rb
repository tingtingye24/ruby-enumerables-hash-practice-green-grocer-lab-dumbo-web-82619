def consolidate_cart(cart)
  newhash = Hash.new
  cart.each do |item|
    if newhash[item.keys[0]]
      newhash[item.keys[0]][:count] += 1
    else
      newhash[item.keys[0]] = {
        :price => item.values[0][:price],
        :clearance => item.values[0][:clearance],
        :count => 1
      }
    end
  end
  newhash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include? coupon[:item]
      if cart[coupon[:item]][:count] >= coupon[:num]
        new_name = "#{coupon[:item]} W/COUPON"
        if cart[new_name]
          cart[new_name][:count] += coupon[:num]
        else
          cart[new_name] = {
            :count => coupon[:num],
            :price => coupon[:cost]/coupon[:num],
            :clearance => cart[coupon[:item]][:clearance]
          }
        end
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.keys.each do |item|
    if cart[item][:clearance]
      cart[item][:price] = (cart[item][:price]*0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolCart = consolidate_cart(cart)
  couponCart = apply_coupons(consolCart, coupons)
  discountCart = apply_clearance(couponCart)
  total = 0.0
  discountCart.keys.each do |item|
    total += discountCart[item][:price]*discountCart[item][:count]
  end
  if total > 100
    total = (total * 0.90).round(2)
  end
  total
end