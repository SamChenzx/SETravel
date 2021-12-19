

function drawExtraArea(canvas, session)
    extraWidth = getExtraWidth(session)
    extraHeight = getExtraHeight(session)
    extraWidth = 0 + 1 * extraWidth
    extraHeight = 26
    drawOneGraphBegin(canvas)
    setAlpha(canvas, 1)
    color = LColor:new(1, 0.18823529411764706, 0.9921568627450981, 0.0392156862745098)
    setFillColor(canvas, color)
    rightV = 0 + extraWidth
    bottomV = 0 + extraHeight
    rect = LRect:new(0, 0, rightV, bottomV)
    drawFillRoundRect(canvas, rect, 5, false, true, false, false)
    drawOneGraphEnd(canvas)

    drawOneGraphBegin(canvas)
    setAlpha(canvas, 1)
    setStrokeCap(canvas, CAP_BUTT)
    setStrokeJoin(canvas, JOIN_ROUND)
    setStrokeWidth(canvas, 1.5)
    color = LColor:new(1, 0, 0, 0)
    setStrokeColor(canvas, color)
    rightV = -0.75 + extraWidth
    bottomV = -0.75 + extraHeight
    rect = LRect:new(0.75, 0.75, rightV, bottomV)
    drawStrokeRoundRect(canvas, rect, 5, false, true, false, false)
    drawOneGraphEnd(canvas)

    drawOneGraphBegin(canvas)
    setAlpha(canvas, 1)
    setStrokeCap(canvas, CAP_BUTT)
    setStrokeJoin(canvas, JOIN_MITER)
    setStrokeWidth(canvas, 1.5)
    color = LColor:new(1, 0, 0, 0)
    setStrokeColor(canvas, color)
    effect = {3.5, 3.5}
    setDashEffect(canvas, 2, effect)
    beginPath(canvas)
    absY = -0.08999999999999986 + extraHeight
    start = LPoint:new(26.9, absY)
    moveToPoint(canvas, start)
    point = LPoint:new(26.9, 1.91)
    lineToPoint(canvas, point)
    drawStrokePath(canvas)
    drawOneGraphEnd(canvas)

    drawOneGraphBegin(canvas)
    setAlpha(canvas, 1)
    setTextSize(canvas, 13)
    color = LColor:new(1, 0, 0, 0)
    setFillColor(canvas, color)
    extraText = getExtraText(session)
    color = LColor:new(1, 0, 0, 0)
    drawText(canvas, 13, color, extraText, 33, 6.5)
    drawOneGraphEnd(canvas)

    drawOneGraphBegin(canvas)
    setAlpha(canvas, 1)
    bottomV = -1 + extraHeight
    rect = LRect:new(1.9999999997862687, 1, 25.99999999978627, bottomV)
    drawBitmap(canvas, "logo.webp", rect)
    drawOneGraphEnd(canvas)

end




