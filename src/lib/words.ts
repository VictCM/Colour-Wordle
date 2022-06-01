import { WORDS } from '../constants/wordlist'
import { VALIDGUESSES } from '../constants/validGuesses'
import { CONFIG } from '../constants/config'

export const isWordInWordList = (word: string) => {
  return WORDS.includes(word) || VALIDGUESSES.includes(word)
}

export const isWinningWord = (word: string) => {
  return solution === word
}

export const getWordOfDay = () => {
  // January 1, 2022 Game Epoch
  const epochMs = new Date(CONFIG.startDate).valueOf()
  const now = Date.now()
  const msInWeek = 604800000
  const index = Math.floor((now - epochMs) / msInWeek)
  const nextweek = (index + 1) * msInWeek + epochMs + 86400000 + 115200000

  return {
    solution: WORDS[index % WORDS.length],
    solutionIndex: index,
    tomorrow: nextweek,
  }
}

export const { solution, solutionIndex, tomorrow } = getWordOfDay()
