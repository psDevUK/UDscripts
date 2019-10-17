import React from "react";
import BeautyStars from "beauty-stars";
class udrate extends React.Component {
  // state is for keeping control state before or after changes.
  state = {
    value: 0
    // the things you want to put in state.
    // text: this.props.text //un comment the line to use state insted props
  };
  onIncomingEvent(eventName, event) {
    if (event.type === "requestState") {
      UniversalDashboard.post(
        `/api/internal/component/element/sessionState/${event.requestId}`,
        {
          attributes: {
            value: this.state.value
          }
        }
      );
    }
  }

  onChanged(u) {
    this.setState({
      value: u.target.value
    });

    if (this.props.onChange == null) {
      return;
    }

    var val = u.target.value;

    UniversalDashboard.publish("element-event", {
      type: "clientEvent",
      eventId: this.props.onChange,
      eventName: "onChange",
      eventData: val.toString()
    });
  }

  render() {
    // These props are returned from PowerShell!
    // return <h1>{this.state.text}</h1> // un comment the line to render using value from state.

    return (
      <BeautyStars
        value={this.state.value}
        onChange={
          (value => this.setState({ value }), this.onChanged.bind(this))
        }
        size={this.props.size}
      />
    );
  }
}

export default udrate;
