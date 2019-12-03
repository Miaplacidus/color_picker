# ColorPicker

## Setup
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Notes
The app makes use of Channels. If you have two windows open and pointed to localhost:4000, changes in one window should be reflected in the other. E.g. If you create a palette in one window, the palette should appear in the palettes list in both windows. The same holds for updates and deletes. 

After entering the desired RGB value in the color picker, palette creator, or palette editor hit 'Enter' to see the changes reflected in the input's corresponding color bar.

Tests can be run using the `mix test` command. Note that the test suite is incomplete. Some of the tests use Hound, so you'll need a browser driver, e.g. phantomjs, chromedriver.
