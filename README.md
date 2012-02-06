This is a light library to access the Backchat provisioning API

# Installation

    gem install backchat-client

# Current version

0.1

# Getting started

You need a valid api-key to access Backchat API

    require 'backchat-client'
	bc = Backchat::Client.new("api-key")
	
# User Management

## Get user profile

    require 'backchat-client'
    bc = Backchat::Client.new("api-key")
    bc.get_profile

## Delete user

    require 'backchat-client'
    bc = Backchat::Client.new("api-key")
    bc.delete_user

# Streams

## Create a new stream

    require 'backchat-client'
    bc = Backchat::Client.new("api-key")
    bc.create_stream("stream-name")

## Retrieve application streams

    require 'backchat-client'
    bc = Backchat::Client.new("api-key")

    # get all streams
    streams = bc.find_stream

    # get a specific stream
    stream = bc.find_stream("stream-name")

## Delete a stream

    require 'backchat-client'
    bc = Backchat::Client.new("api-key")
    bc.destroy_stream("stream-name")

# Channels

## Create a new channel

    require 'backchat-client'
    bc = Backchat::Client.new("api-key")
    bc.create_channel("twitter", "juandebravo")

## Retrieve application channels

    require 'backchat-client'
    bc = Backchat::Client.new("api-key")

    # get all channels
    streams = bc.find_channel

## Delete a channel

    require 'backchat-client'
    bc = Backchat::Client.new("api-key")
    bc.destroy_channel("twitter://juandebravo")

# License

    The MIT License

    Copyright (c) 2011 Juan de Bravo, Alberto Pastor, Rafael de Oleza.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
