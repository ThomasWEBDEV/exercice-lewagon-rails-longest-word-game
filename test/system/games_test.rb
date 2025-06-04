require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert_text "Longest Word Game"
    assert_selector ".letter-tile", count: 10
  end

  test "Submitting a word that is not in the grid shows the correct error message" do
    visit new_url
    fill_in "word", with: "ZZZZZ"
    click_on "Submit"
    assert_text "can't be built out of the original grid"
  end

  test "Submitting a word that is in the grid but not an English word shows the correct error" do
    visit new_url
    letters = all(".letter-tile").map(&:text).map(&:downcase)

    # Construire un faux mot uniquement avec des lettres uniques
    letter_counts = letters.tally
    possible_fake = letter_counts.map { |letter, count| letter * [1, count].min }.join
    fake_word = possible_fake.reverse # inversé pour éviter les vrais mots

    fill_in "word", with: fake_word
    click_on "Submit"

    assert_text "not a valid English word"
  end

  test "Submitting a valid English word in the grid shows a success message" do
    visit new_url
    letters = all(".letter-tile").map(&:text).join.downcase

    valid_word = %w[car son bin box rock coin]

    word = valid_word.find { |w| w.chars.all? { |l| letters.count(l) >= w.count(l) } }

    if word
      fill_in "word", with: word
      click_on "Submit"
      assert_text "Well done"
    else
      skip "No valid test word found in current grid"
    end
  end
end
