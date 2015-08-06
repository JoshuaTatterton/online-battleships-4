require 'spec_helper'

feature 'Starting a new game' do
  scenario 'I am asked to enter my name' do
    visit '/'
    click_link 'New Game'
    expect(page).to have_content "What's your name?"
  end

  feature 'Entering player 1 & player 2 names' do
    scenario 'registers a name' do
      visit '/'
      click_link 'New Game'
      fill_in :name, with: 'Dan'
      fill_in :name2, with: 'Ed'
      click_on 'Submit'
      expect(page).to have_content 'Hello, Dan and Ed!'
    end

    scenario 'no name entered' do
      visit '/'
      click_link 'New Game'
      fill_in (:name or :name2) , with: ''
      click_on 'Submit'
      expect(page).to have_content 'Hello, and !'
    end
  end
end

feature 'playing a new game' do
  feature 'player 1 playing a game' do
    scenario "can place ships" do
      startgame
      expect(page).to have_content "Where do you want to place your ship?"
      placeships
      expect(page).to have_content "Where do you want to place your ship?"
    end

    scenario 'can see a player 1 board' do
      game = Game.new Player, Board
      board = game.opponent_board_view game.player_1
      visit '/new_game'
      click_button 'Submit'
      click_link 'Enter Game Arena'
      placeships
      placeships
      expect(page).to have_content board
    end

    scenario 'I am asked to enter a board coordinate' do
      visit '/new_game'
      fill_in "name", with: 'Dave'
      click_button 'Submit'
      click_link 'Enter Game Arena'
      placeships
      placeships
      expect(page).to have_content 'Please enter board coordinate to shoot at:'
    end

    scenario 'should hit on the board' do
      startgame
      placeships
      placeships
      p1fire "D4"
      expect(page).to have_content 'miss' or 'hit'
    end

    scenario 'should hit the ship' do
      startgame
      placeships
      placeships
      p1fire "e4"
      expect(page).to have_content 'hit'
    end

    scenario 'should sink the ship' do
      startgame
      placeships
      placeships
      p1fire "a1"
      p2fire "b1"
      p1fire "b1"
      p2fire "c1"
      p1fire "c1"
      p2fire "d1"
      p1fire "d1"
      expect(page).to have_content 'sunk'
    end
    scenario 'should win the game' do
      startgame
      placeships
      placeships
      p1fire "a1"
      p2fire "b1"
      p1fire "b1"
      p2fire "c1"
      p1fire "c1"
      p2fire "d1"
      p1fire "d1"
      p2fire "E4"
      p1fire "e5"
      p2fire "e5"
      p1fire "e6"
      p2fire "e6"
      p1fire "e7"
      p2fire "j1"
      p1fire "e4"
      p2fire "i8"
      p1fire "e8"
      expect(page).to have_content 'Player 1 Wins!'
    end
  end

  feature 'player 2 playing a game' do
    scenario "can place ships" do
      startgame
      expect(page).to have_content "Where do you want to place your ship?"
      placeships
      expect(page).to have_content "Where do you want to place your ship?"
      placeships
      expect(page).to have_content 'Please enter board coordinate to shoot at:'
    end
    scenario 'can see a player 2 board' do
      game = Game.new Player, Board
      board = game.opponent_board_view game.player_2
      visit '/new_game'
      click_button 'Submit'
      click_link 'Enter Game Arena'
      placeships
      placeships
      expect(page).to have_content board
    end

    scenario 'I am asked to enter a board coordinate' do
      startgame
      placeships
      placeships
      expect(page).to have_content 'Please enter board coordinate to shoot at:'
    end

    scenario 'should hit on the board' do
      startgame
      expect(page).to have_content "Where do you want to place your ship?"
      placeships
      expect(page).to have_content "Where do you want to place your ship?"
      placeships
      p1fire "D4"
      p2fire "D4"
      expect(page).to have_content 'miss' or 'hit'
    end

    scenario 'should hit the ship' do
      startgame
      placeships
      placeships
      p1fire "E4"
      p2fire "e4"
      expect(page).to have_content 'hit'
    end

    scenario 'should sink the ship' do
      startgame
      placeships
      placeships
      p1fire "a1"
      p2fire "b1"
      p1fire "b1"
      p2fire "c1"
      p1fire "c1"
      p2fire "d1"
      p1fire "d1"
      p2fire "a1"
      expect(page).to have_content 'sunk'
    end

    scenario 'should win the game' do
      startgame
      placeships
      placeships
      p1fire "a1"
      p2fire "b1"
      p1fire "b1"
      p2fire "c1"
      p1fire "c1"
      p2fire "d1"
      p1fire "d1"
      p2fire "a1"
      p1fire "e5"
      p2fire "e5"
      p1fire "e6"
      p2fire "e6"
      p1fire "e7"
      p2fire "e7"
      p1fire "j1"
      p2fire "e8"
      p1fire "i9"
      p2fire "E4"
      expect(page).to have_content 'Player 2 Wins!'
    end
  end
end

def startgame
  visit '/'
  click_link 'New Game'
  click_button 'Submit'
  click_link 'Enter Game Arena'
end

def placeships
  fill_in "coordinate", with: "e4"
  select "vertically", :from => "rotation"
  fill_in "coordinate2", with: "A1"
  select "horizontally", :from => "rotation2"
  click_button "Submit"
end
def p1fire coord
  fill_in "coordinate", with: coord
  click_button 'Submit'
end
def p2fire coord
  fill_in "coordinate2", with: coord
  click_button 'Submit'
end
