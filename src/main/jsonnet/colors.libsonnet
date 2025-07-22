{
  a_bigger_value_is_a_problem: {
    steps: if (std.extVar("EXT_THEME") == "blue_white_red") then
            $.a_bigger_value_is_a_problem.blue_white_red.steps
        else if (std.extVar("EXT_THEME") == "rainbow") then
            $.a_bigger_value_is_a_problem.rainbow.steps
        else
            $.a_bigger_value_is_a_problem.blue_white_red.steps,
    blue_white_red: {
      steps: [
        {
          color: '#cc0000',
          value: null,
        },
        { color: '#3c78d8', value: -90 },
        { color: '#5187dc', value: -80 },
        { color: '#6796e0', value: -70 },
        { color: '#7da5e5', value: -60 },
        { color: '#92b4e9', value: -50 },
        { color: '#a8c3ed', value: -40 },
        { color: '#bed2f2', value: -30 },
        { color: '#d3e1f6', value: -20 },
        { color: '#e9f0fa', value: -10 },
        { color: '#ffffff', value: 0.0 },
        { color: '#fae3e3', value: 10 },
        { color: '#f4c7c7', value: 20 },
        { color: '#efabab', value: 30 },
        { color: '#e98e8e', value: 40 },
        { color: '#e37272', value: 50 },
        { color: '#de5656', value: 60 },
        { color: '#d83939', value: 70 },
        { color: '#d21d1d', value: 80 },
        { color: '#cc0000', value: 90 },
      ],
    },
    rainbow: {
      steps: [
        {
          color: '#990000',
          value: null,
        },
        { color: '#674ea7', value: -90 },
        { color: '#8e7cc3', value: -80 },
        { color: '#3d85c6', value: -70 },
        { color: '#3d85c6', value: -60 },
        { color: '#3c78d8', value: -50 },
        { color: '#6d9eeb', value: -40 },
        { color: '#a4c2f4', value: -30 },
        { color: '#c9daf8', value: -20 },
        { color: '#93c47d', value: -10 },
        { color: '#6aa84f', value: 0.0 },
        { color: '#93c47d', value: 10 },
        { color: '#ffe599', value: 20 },
        { color: '#ffd966', value: 30 },
        { color: '#f1c232', value: 40 },
        { color: '#f6b26b', value: 50 },
        { color: '#e69138', value: 60 },
        { color: '#b45f06', value: 70 },
        { color: '#cc0000', value: 80 },
        { color: '#990000', value: 90 },
      ],
    },
    white_rainbow: {

    },
  },

  a_bigger_value_is_better: {
      steps: if (std.extVar("EXT_THEME") == "blue_white_red") then
              $.a_bigger_value_is_better.blue_white_red.steps
          else if (std.extVar("EXT_THEME") == "rainbow") then
              $.a_bigger_value_is_better.rainbow.steps
          else
              $.a_bigger_value_is_better.blue_white_red.steps,
    blue_white_red: {
      steps: [
        {
          color: '#1155cc',
          value: null,
        },
        { color: '#cc0000', value: -90 },
        { color: '#d11c1c', value: -80 },
        { color: '#d73838', value: -70 },
        { color: '#dd5555', value: -60 },
        { color: '#e27171', value: -50 },
        { color: '#e88d8d', value: -40 },
        { color: '#eeaaaa', value: -30 },
        { color: '#f3c6c6', value: -20 },
        { color: '#f9e2e2', value: -10 },
        { color: '#ffffff', value: 0.0 },
        { color: '#e5edfa', value: 10 },
        { color: '#cbdaf4', value: 20 },
        { color: '#b0c7ef', value: 30 },
        { color: '#96b4e9', value: 40 },
        { color: '#7ba1e3', value: 50 },
        { color: '#618ede', value: 60 },
        { color: '#467bd8', value: 70 },
        { color: '#2c68d2', value: 80 },
        { color: '#1155cc', value: 90 },
      ],
    },
    rainbow: {
      steps: [
        {
          color: '#674ea7',
          value: null,
        },
        { color: '#990000', value: -90 },
        { color: '#cc0000', value: -80 },
        { color: '#b45f06', value: -70 },
        { color: '#e69138', value: -60 },
        { color: '#f6b26b', value: -50 },
        { color: '#f1c232', value: -40 },
        { color: '#ffd966', value: -30 },
        { color: '#ffe599', value: -20 },
        { color: '#93c47d', value: -10 },
        { color: '#6aa84f', value: 0 },
        { color: '#93c47d', value: 10 },
        { color: '#c9daf8', value: 20 },
        { color: '#a4c2f4', value: 30 },
        { color: '#6d9eeb', value: 40 },
        { color: '#3c78d8', value: 50 },
        { color: '#3d85c6', value: 60 },
        { color: '#3d85c6', value: 70 },
        { color: '#8e7cc3', value: 80 },
        { color: '#674ea7', value: 90 },
      ],
    },
  },
}
