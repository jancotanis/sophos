require "test_helper"


describe 'pagination' do
  before do
    Dotenv.load
  end

  it "#1 GET pager" do
    pager = Sophos::RequestPagination::PagesPagination.new(0)
    assert value(pager.current).must_equal(1), "start at current page 1"
    assert pager.more_pages?, "should have .more_pages?"
    pager.next_page!({})
    refute pager.more_pages?, "no page info, should not have .more_pages?"
  end
  it "#2 GET pager" do
    pager = Sophos::RequestPagination::PagesPagination.new(0)
    assert value(pager.current).must_equal(1), "start at current page 1"
    assert pager.more_pages?, "should have .more_pages?"
    page = {"pages" => {
        "current" => 1,
        "size" => 50,
        "total" => 3,
        "maxSize" => 100
    }}
    pager.next_page!(page)
    assert pager.more_pages?, "should have 1/3 .more_pages?"
    page = {"pages" => {
        "current" => 3,
        "size" => 50,
        "total" => 3,
        "maxSize" => 100
    }}
    pager.next_page!(page)
    refute pager.more_pages?, "should not have 3/3 .more_pages?"
  end
end
