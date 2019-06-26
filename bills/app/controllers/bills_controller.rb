class BillsController < ApplicationController

  # GET: /bills
  get "/bills" do
    erb :"/bills/index.html"
  end

  # GET: /bills/new
  get "/bills/new" do
    erb :"/bills/new.html"
  end

  # POST: /bills
  post "/bills" do
    redirect "/bills"
  end

  # GET: /bills/5
  get "/bills/:id" do
    erb :"/bills/show.html"
  end

  # GET: /bills/5/edit
  get "/bills/:id/edit" do
    erb :"/bills/edit.html"
  end

  # PATCH: /bills/5
  patch "/bills/:id" do
    redirect "/bills/:id"
  end

  # DELETE: /bills/5/delete
  delete "/bills/:id/delete" do
    redirect "/bills"
  end
end
