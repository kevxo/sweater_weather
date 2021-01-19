require 'rails_helper'

describe 'User API' do
  it 'can create user and give error messages if user exists' do
    user = {
      "email": 'whatever@example.com',
      "password": 'password',
      "password_confirmation": 'password'
    }
    post '/api/v1/users', params: user.to_json,
                          headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    expect(response).to be_successful
    expect(response.status).to eq(201)

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json).to be_a Hash
    expect(json).to have_key :data
    expect(json[:data]).to have_key :id
    expect(json[:data][:id]).to_not eq(nil)
    expect(json[:data][:id]).to be_a String
    expected = %i[email api_key]
    expect(json[:data][:attributes].keys).to eq(expected)
    expect(json[:data][:attributes][:email]).to be_a String
    expect(json[:data][:attributes][:api_key]).to be_a String

    user2 = {
      "email": 'WhatEver@example.com',
      "password": 'password',
      "password_confirmation": 'password'
    }
    post '/api/v1/users', params: user2.to_json,
                          headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    json = JSON.parse(response.body, symbolize_names: true)
    expect(json.first).to eq('Email has already been taken')

    user3 = {
      "email": 'whatever@example.com',
      "password": 'p12assword',
      "password_confirmation": 'password'
    }

    post '/api/v1/users', params: user3.to_json,
                          headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    json = JSON.parse(response.body, symbolize_names: true)
    expect(json.first).to eq("Password confirmation doesn't match Password")

    user4 = {
      "email": '',
      "password": 'password',
      "password_confirmation": 'password'
    }

    post '/api/v1/users', params: user4.to_json,
                          headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    json = JSON.parse(response.body, symbolize_names: true)
    expect(json.first).to eq("Email can't be blank")
  end

  it 'user can login and will get error if login is incorrect' do
    user = {
      "email": 'whatever@example.com',
      "password": 'password',
      "password_confirmation": 'password'
    }
    post '/api/v1/users', params: user.to_json,
                          headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    user = {
      "email": 'whatever@example.com',
      "password": 'password'
    }

    post '/api/v1/sessions', params: user.to_json,
                             headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    expect(response).to be_successful
    expect(response.status).to eq(200)

    json = JSON.parse(response.body, symbolize_names: true)
    expect(json).to be_a Hash
    expect(json).to have_key :data
    expect(json[:data]).to have_key :attributes
    expected = %i[email api_key]
    expect(json[:data][:attributes].keys).to eq(expected)
    expect(json[:data][:attributes][:email]).to be_a String
    expect(json[:data][:attributes][:api_key]).to be_a String

    user2 = {
      "email": 'whatever@example.com',
      "password": 'pcjsi'
    }

    post '/api/v1/sessions', params: user2.to_json,
                             headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json).to be_a Hash
    expect(json).to have_key :error
    expect(json[:error]).to eq('credentials are incorrect')
  end
end
