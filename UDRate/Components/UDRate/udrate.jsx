
import React,{useState} from 'react';
import BeautyStars from "beauty-stars";
import useDashboardEvent from '../Hooks/useDashboardEvent';

const UDRate = props => {
	const [state, reload] = useDashboardEvent(props.id, props);
	const { content, attributes } = state;
	const [value, setValue] = useState(0)

	const onChange = newStar => {
		attributes.hasCallBack ? setValue(newStar) : null
		
		UniversalDashboard.publish('element-event', {
			type: 'clientEvent',
			eventId: attributes.id + 'OnChange',
			eventName: 'onChange',
			eventData: newStar.toString()
		});
	};

	return <BeautyStars {...attributes} value={value} onChange={onChange} />;
};

export default UDRate;
