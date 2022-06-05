import { WORDS } from '../constants/wordlist'
import { VALIDGUESSES } from '../constants/validGuesses'
import { CONFIG } from '../constants/config'

export const isWordInWordList = (word: string) => {
  return WORDS.includes(word) || VALIDGUESSES.includes(word)
}

export const isWinningWord = (word: string) => {
  return solution === word
}

function getNextMonday() {
  const now = new Date()
  const today = new Date(now)
  today.setMilliseconds(0)
  today.setSeconds(0)
  today.setMinutes(0)
  today.setHours(0)

  const nextMonday = new Date(today)

  do {
    nextMonday.setDate(nextMonday.getDate() + 1) // Adding 1 day
  } while (nextMonday.getDay() !== 1)

  return nextMonday
}

export const getWordOfDay = () => {
  // January 1, 2022 Game Epoch
  const epochMs = new Date(CONFIG.startDate).valueOf()
  const now = Date.now()
  const msinDay = 86400000
  const index = Math.floor((now - epochMs) / msinDay)

  return {
    solution: WORDS[index % WORDS.length],
    solutionIndex: index,
    tomorrow: getNextMonday(),
  }
}

export const { solution, solutionIndex, tomorrow } = getWordOfDay()
