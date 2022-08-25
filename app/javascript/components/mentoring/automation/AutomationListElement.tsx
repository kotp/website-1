import React, { useEffect } from 'react'
import { fromNow } from '../../../utils/time'
import { TrackIcon, ExerciseIcon, GraphicalIcon } from '../../common'
import { Representation } from '../../types'

export const AutomationListElement = ({
  representation,
}: {
  representation: Representation
}): JSX.Element => {
  useEffect(() => {
    console.log('REPRESENTATIONL')
  }, [representation])

  return (
    <a className="--representer" href={'string'}>
      <TrackIcon
        title={representation.track.title}
        iconUrl={representation.track.iconUrl}
      />
      <ExerciseIcon
        title={representation.exercise.title}
        iconUrl={representation.exercise.iconUrl}
      />
      <div className="--info">
        <div className="--exercise-title">
          <div>{representation.exercise.title}</div>{' '}
          <div className="--most-popular">Most Popular</div>
        </div>
        <div className="--track-title">
          in {representation.track.title} (#520)
        </div>
      </div>
      <div
        className="--feedback-glimpse"
        dangerouslySetInnerHTML={{ __html: representation.feedbackHtml }}
      ></div>
      <div className="--occurencies">{representation.numSubmissions}</div>
      <time className="whitespace-nowrap">
        Last shown
        <br />
        {fromNow(representation.lastSubmittedAt)}
      </time>
      <GraphicalIcon
        icon="chevron-right"
        className="action-icon textColor6-filter"
      />
    </a>
  )
}
