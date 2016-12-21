class HomeController < ApplicationController
  # before_action :set_defaults

  def test

  end

  def index
    render layout: "index"
  end


  private

  def set_defaults
    @aapl = JSON.parse(Quote.find(1173).financials)
    @financials = @aapl['financials']
    @insider = JSON.parse(Quote.find(187).insider)['AAPL']

    @donut = []
    dt = {label: 'Pre-Tax Income', value: @aapl['financials']['annuals']['income_statement']['Pre-Tax Income'][-1].to_i }
    @donut.push(dt)
    dt = {label: 'Pre-Tax Income', value: @aapl['financials']['annuals']['income_statement']['Depreciation, Depletion and Amortization'][-1].to_i }
    @donut.push(dt)
    dt = {label: 'Pre-Tax Income', value: @aapl['financials']['annuals']['income_statement']['Interest Expense'][-1].to_i.abs }
    @donut.push(dt)


    yahoo_client = YahooFinance::Client.new

    @pdata = []
    yahoo_client.historical_quotes("CSIQ").each do |d|
      input = [d.trade_date, d.open.to_f.round(2)]
      @pdata.insert(0,input)
    end
    gon.highdata = @pdata.to_json



    @currency = yahoo_client.quotes(["USDCAD=X","USDGBP=X","USDEUR=X","USDAUD=X","USDINR=X","USDCNY=X","USDHKD=X","USDKRW=X","USDNZD=X","USDSGD=X","USDCHF=X","USDJPY=X","USDZAR=X","USDBRL=X","USDMXN=X"], [:ask])

    @exchange = []
    @currency.each do |c|
      @exchange.push(c.ask.to_f)
    end


    @data = yahoo_client.quotes(['AAPL'], [
      :after_hours_change_real_time,
      :annualized_gain,
      :ask,
      :ask_real_time,
      :ask_size,
      :average_daily_volume,
      :bid,
      :bid_real_time,
      :bid_size,
      :book_value,
      :change,
      :change_and_percent_change,
      :change_from_200_day_moving_average,
      :change_from_50_day_moving_average,
      :change_from_52_week_high,
      :change_in_percent,
      :change_percent_realtime,
      :change_real_time,
      :close,
      :comission,
      :day_value_change,
      :day_value_change_realtime,
      :days_range,
      :days_range_realtime,
      :dividend_pay_date,
      :dividend_per_share,
      :dividend_yield,
      :earnings_per_share,
      :ebitda,
      :eps_estimate_current_year,
      :eps_estimate_next_quarter,
      :eps_estimate_next_year,
      :error_indicator,
      :ex_dividend_date,
      :float_shares,
      :high,
      :high_52_weeks,
      :high_limit,
      :holdings_gain,
      :holdings_gain_percent,
      :holdings_gain_percent_realtime,
      :holdings_gain_realtime,
      :holdings_value,
      :holdings_value_realtime,
      :last_trade_date,
      :last_trade_price,
      :last_trade_realtime_withtime,
      :last_trade_size,
      :last_trade_time,
      :last_trade_with_time,
      :low,
      :low_52_weeks,
      :low_limit,
      :market_cap_realtime,
      :market_capitalization,
      :more_info,
      :moving_average_200_day,
      :moving_average_50_day,
      :name,
      :notes,
      :one_year_target_price,
      :open,
      :order_book,
      :pe_ratio,
      :pe_ratio_realtime,
      :peg_ratio,
      :percent_change_from_200_day_moving_average,
      :percent_change_from_50_day_moving_average,
      :percent_change_from_52_week_high,
      :percent_change_from_52_week_low,
      :previous_close,
      :price_eps_estimate_current_year,
      :price_eps_Estimate_next_year,
      :price_paid,
      :price_per_book,
      :price_per_sales,
      :revenue,
      :shares_outstanding,
      :shares_owned,
      :short_ratio,
      :stock_exchange,
      :symbol,
      :ticker_trend,
      :trade_date,
      :trade_links,
      :volume,
      :weeks_range_52
      ], { raw: false } )

    end
  end
