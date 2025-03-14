import { CharStatus } from '../../lib/statuses'
import classnames from 'classnames'

type Props = {
  value?: string
  status?: CharStatus
}

export const Cell = ({ value, status }: Props) => {
  const classes = classnames(
    'w-14 h-14 border-solid border-negro border-2 flex items-center justify-center mx-0.5 text-lg font-bold rounded text-blanco',
    {
      'bg-white text-negro': !status,
      'border-black': value && !status,
      'bg-gris': status === 'absent',
      'bg-coral': status === 'present',
      'bg-burdeos': status === 'correct',
      'bg-naranja': status === 'solved',
      'cell-animation': !!value,
    }
  )

  return <div className={classes}>{value}</div>
}
