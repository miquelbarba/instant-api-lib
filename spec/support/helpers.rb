module Helpers
  def validate_user(user, expected_user)
    user[:id].should_not be_nil
    user[:age].should eq(expected_user[:age])
    Date.parse(user[:born_at]).should eq(expected_user[:born_at].to_date)
    DateTime.parse(user[:registered_at]).to_i.should eq(expected_user[:registered_at].to_i)
    user[:terms_accepted].should eq(expected_user[:terms_accepted])
    user[:email].should eq(expected_user[:email])
    BigDecimal.new(user[:money]).should eq(expected_user[:money])
    user[:created_at].should_not be_nil
    user[:updated_at].should_not be_nil
  end

  def validate_pagination(pagination, count, page, per_page)
    pagination = pagination.symbolize_keys
    pagination[:count].should eq(count)
    pagination[:page].should eq(page)
    pagination[:per_page].should eq(per_page)
  end

  def validate_user_collection(collection, expected_collection)
    collection.each_with_index do |user, index|
      validate_user(user.symbolize_keys, expected_collection[index])
    end
  end

  def validate_errors(body, expected_errors)
    json = JSON.parse(body).symbolize_keys
    json[:errors].should eq(expected_errors)
  end
end