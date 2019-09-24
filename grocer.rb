require "pry"
def consolidate_cart(cart)
    final_hash= {}
    cart.each do |row_hash|
        name= row_hash.keys[0]
        if !final_hash[name]
            final_hash[name] = row_hash[name]
            final_hash[name][:count] = 1
        else
            final_hash[name][:count]+=1
        end
    end
    final_hash
end


def apply_coupons(cart, coupons)
 coupons.each do |coupon|
item_name = coupon[:item]
if cart[item_name]
  if cart[item_name][:count]>= coupon[:num] and !cart["#{item_name} W/COUPON"]
    cart["#{item_name} W/COUPON"] = {
      price: coupon[:cost] / coupon[:num],
      clearance: cart[item_name][:clearance],
      count: coupon[:num]
    }
    cart[item_name][:count]-= coupon[:num]
  elsif cart[item_name][:count]>= coupon[:num] && cart["#{item_name} W/COUPON"]
    cart["#{item_name} W/COUPON"][:count]+= coupon[:num]
    cart[item_name][:count]-= coupon[:num]
  end
end

 end
cart
end

def apply_clearance(cart)
  final_hash ={}
cart.each do |k,v|
  last_price= cart[k][:price] * 0.20
if cart[k][:clearance]
  final_hash["#{k}"] ={
    price: cart[k][:price] - last_price,
    clearance: cart[k][:clearance],
    count: cart[k][:count]
  }
elsif !cart[k][:clearance]
final_hash["#{k}"] = v
end
end
final_hash
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  after_coupons = apply_coupons(new_cart,coupons)
  apply_clearance(after_coupons)
end
