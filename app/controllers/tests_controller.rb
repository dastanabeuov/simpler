class TestsController < Simpler::Controller

  def index
    status 200
    set_custom_headers ({'Custom-Header' => 'custom-value', 'Custom-Header-2' => 'custom-value-2'})  	
    #@time = Time.now
  end

  def show
    render plain: "Show action\nThe id of this request is #{find_test_id}\n"
  end

  def create

  end

  private

  def find_test_id
    params["test"].to_i
  end    

end
