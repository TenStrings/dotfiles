/* eslint-env jest */
import { render, cleanup } from 'react-testing-library';
import React from 'react';

afterEach(cleanup);

test("Test name" , () => {
    {getByName} = render (<div> </div>)
});
