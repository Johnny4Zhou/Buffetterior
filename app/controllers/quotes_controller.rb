class QuotesController < ApplicationController

  def financials
    @quote = Quote.find params[:quote_id]
    @financials = JSON.parse(@quote.financials)['financials']
    @annual = @financials['annuals']
    @quarterly = @financials['quarterly']
  end

  def search
    @search = params[:content]
    quote = Quote.find_by_symbol(@search)
    if quote
      redirect_to quote_path(quote)
    else
      redirect_to :back, notice: 'Quote does not exists, try again.'
    end
  end

  def show
    @quote = Quote.find params[:id]
    yahoo_client = YahooFinance::Client.new

    @currency = yahoo_client.quotes(["USDCAD=X",
                                    "USDGBP=X",
                                    "USDEUR=X",
                                    "USDAUD=X",
                                    "USDINR=X",
                                    "USDCNY=X",
                                    "USDHKD=X",
                                    "USDKRW=X",
                                    "USDNZD=X",
                                    "USDSGD=X",
                                    "USDCHF=X",
                                    "USDJPY=X",
                                    "USDZAR=X",
                                    "USDBRL=X",
                                    "USDMXN=X"], [:ask])

    @exchange = []
    @currency.each do |c|
     @exchange.push(c.ask.to_f)
    end

    @data = yahoo_client.quotes([@quote.symbol], [
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


    @pdata = []
    begin
      yahoo_client.historical_quotes(@quote.symbol).each do |d|
        input = [d.trade_date, d.open.to_f.round(2)]
        @pdata.insert(0,input)
      end
    rescue Zlib::DataError => e

      logger.error e
    end

    gon.highdata = @pdata.to_json
    gon.symbol = @quote.symbol

    if @quote.financials.nil?
    conn =  Faraday.new(url: 'https://www.gurufocus.com/')
    response =  conn.get('/api/public/user/1b3b5993f9d79340b5709e0f03fbbe88:fd53750c8980101173537ddc642308f4/stock/'+@quote.symbol+'/financials')
    @quote.financials = response.body
    @quote.save
    else
    puts "financials is not empty"
    end

    # if a.insider.nil?
    # conn =  Faraday.new(url: 'https://www.gurufocus.com/')
    # response =  conn.get('/api/public/user/1b3b5993f9d79340b5709e0f03fbbe88:fd53750c8980101173537ddc642308f4/stock/'+a.symbol+'/insider')
    # a.insider = response.body
    # a.save
    # else
    # puts "insider is not empty"
    # end

    @financials = JSON.parse(@quote.financials)['financials']
    @annual = @financials['annuals']

    gon.pe = " "
    gon.revenue = analysisdata(@annual['income_statement']['Revenue'])
    gon.earning = analysisdata(@annual['income_statement']['EBITDA'])
    gon.eps = analysisdata(@annual['income_statement']['EPS (Basic)'])
    if @annual['valuation_ratios']['PE Ratio(TTM)']
    gon.pe = analysisdata(@annual['valuation_ratios']['PE Ratio(TTM)'])
    end

    if @quote.symbol == 'GOOGL' || @quote.symbol == 'FB'  || @quote.symbol == 'BBRY'
      @num1 = -1
      @num2 = -2
    else
      @num1 = -2
      @num2 = -3
    end

    income_analysis
    ratio_analysis
    price_analysis
    final_conclusion
    gon.donuts = incomedonaut

  end

private

  def income_analysis
    @revenu_score = 0
    @earning_score = 0
  if @annual['Fiscal Year'].size >= 2
    if  last_revenue > last_last_revenue
     @revenu_score += 1
    end
    if last_earning > last_last_earning
     @earning_score += 1
    end
    @recent_earning = last_earning
  else
    puts '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<less than 2'
    @revenu_score = -1
    @earning_score = -1
  end
  end

  def ratio_analysis
    @eps_score = 0
    @pe_score = 0
    @pe_exists = false
    if @annual['Fiscal Year'].size >= 2
      if  last_eps > last_last_eps
       @eps_score += 1
      end
      if @annual['valuation_ratios']['PE Ratio(TTM)']
        @pe_exists = true
        if (5<last_pe) && (last_pe<25)
          @pe_score += 1
        else
          if last_pe < last_last_pe
           @pe_score += 1
          end
        end
      end
    else
      puts '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<less than 2'
      @revenu_score = -1
      @earning_score = -1
    end
  end

  def price_analysis
    @moving_avg_score = 0
    @price_score = 0
    if @data[0].percent_change_from_52_week_high
      changehigh = @data[0].percent_change_from_52_week_high.to_f.abs
      changelow = @data[0].percent_change_from_52_week_low.to_f
      if changehigh > changelow
        @price_score +=1
      end
    else
      @price_score = -1
    end


    if @data[0].moving_average_50_day
      @fiftyday=@data[0].moving_average_50_day.to_f
      @twohunday=@data[0].moving_average_200_day.to_f
      if @fiftyday < @twohunday
        @moving_avg_score += 1
      end
    else
      @moving_avg_score = -1
    end
  end

  def final_conclusion
    overall_score = @revenu_score + @earning_score + @eps_score + @pe_score

    if overall_score > 2
      if (@moving_avg_score > 0)&&(@price_score > 0)
        @final_score = 1
      elsif (@moving_avg_score == 0)&&(@price_score > 0)
        @final_score = 1
      elsif (@moving_avg_score == 0)&&(@price_score == 0)
        @final_score = 0
      elsif (@moving_avg_score > 0)&&(@price_score == 0)
        @final_score = 0
      elsif (@moving_avg_score < 0)||(@price_score < 0)
        @final_score = -2
      else
        @final_score = 0
      end
    elsif overall_score == 2
      if (@moving_avg_score > 0)&&(@price_score > 0)
        @final_score = 1
      elsif (@moving_avg_score == 0)&&(@price_score > 0)
        @final_score = 1
      elsif (@moving_avg_score == 0)&&(@price_score == 0)
        @final_score = 0
      elsif (@moving_avg_score > 0)&&(@price_score == 0)
        @final_score = 0
      elsif (@moving_avg_score < 0)||(@price_score < 0)
        @final_score = -2
      else
        @final_score = 0
      end
    else
      if (@moving_avg_score > 0)&&(@price_score > 0)
        @final_score = 0
      elsif (@moving_avg_score == 0)&&(@price_score > 0)
        @final_score = 0
      elsif (@moving_avg_score == 0)&&(@price_score == 0)
        @final_score = -1
      elsif (@moving_avg_score > 0)&&(@price_score == 0)
        @final_score = -1
      elsif (@moving_avg_score < 0)||(@price_score < 0)
        @final_score = -2
      else
        @final_score = -1
      end
    end
  end

  def last_eps
    @annual['income_statement']['EPS (Basic)'][@num1].to_f
  end
  def last_last_eps
    @annual['income_statement']['EPS (Basic)'][@num2].to_f
  end

  def last_pe
    @annual['valuation_ratios']['PE Ratio(TTM)'][@num1].to_f
  end
  def last_last_pe
    @annual['valuation_ratios']['PE Ratio(TTM)'][@num2].to_f
  end


  def last_revenue
    @annual['income_statement']['Revenue'][@num1].to_f
  end
  def last_last_revenue
    @annual['income_statement']['Revenue'][@num2].to_f
  end


  def last_earning
    @annual['income_statement']['EBITDA'][@num1].to_f
  end
  def last_last_earning
    @annual['income_statement']['EBITDA'][@num2].to_f
  end


  def analysisdata(hdata)
    outdata = []
    for i in 0..@annual['Fiscal Year'].size-1
      outdata.push([@annual['Fiscal Year'][i], hdata[i].to_f.round(2)])
    end
    outdata
  end

  def incomedonaut
    donut = []
    dt = {label: 'Pre-Tax Income', value: @annual['income_statement']['Pre-Tax Income'][-1].to_i.abs }
    donut.push(dt)
    dt = {label: 'Depreciation and Amortization', value: @annual['income_statement']['Depreciation, Depletion and Amortization'][-1].to_i.abs }
    donut.push(dt)
    dt = {label: 'Interest Expense', value: @annual['income_statement']['Interest Expense'][-1].to_i.abs }
    donut.push(dt)
  end
end
