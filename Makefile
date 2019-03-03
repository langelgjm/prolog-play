test:
	swipl -s test_utils.prolog -g run_tests -g halt

# ensure this event unifies with the specified goal
run:
	swipl -s events.prolog -g "x_success" -g halt -- input.json

# run with a goal that fails
fail:
	swipl -s events.prolog -g "failure" -g halt -- input.json