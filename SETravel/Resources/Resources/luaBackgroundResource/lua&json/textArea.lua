

function drawTextArea(canvas, session)
    contentWidth = getTextWidth(session)
    contentHeight = getContentHeight(session)
    contentWidth = 0 + 1 * contentWidth
    contentHeight = -24 + 1 * contentHeight
    drawOneGraphBegin(canvas)
    setAlpha(canvas, 1)
    color = LColor:new(1, 0, 0, 0)
    setFillColor(canvas, color)
    rightV = -32 + contentWidth
    bottomV = -0.5 + contentHeight
    rect = LRect:new(5, 5.5, rightV, bottomV)
    drawFillRoundRect(canvas, rect, 15)
    drawOneGraphEnd(canvas)

    drawOneGraphBegin(canvas)
    setAlpha(canvas, 1)
    color = LColor:new(1, 1, 1, 1)
    setFillColor(canvas, color)
    rightV = -32 + contentWidth
    bottomV = -4.5 + contentHeight
    rect = LRect:new(0, 0.5, rightV, bottomV)
    drawFillRoundRect(canvas, rect, 12.5, false, true, true, true)
    drawOneGraphEnd(canvas)

    drawOneGraphBegin(canvas)
    setAlpha(canvas, 1)
    setStrokeCap(canvas, CAP_BUTT)
    setStrokeJoin(canvas, JOIN_MITER)
    setStrokeWidth(canvas, 1.5)
    color = LColor:new(1, 0, 0, 0)
    setStrokeColor(canvas, color)
    rightV = -32.75 + contentWidth
    bottomV = -5.25 + contentHeight
    rect = LRect:new(0.75, 1.25, rightV, bottomV)
    drawStrokeRoundRect(canvas, rect, 12.5, false, true, true, true)
    drawOneGraphEnd(canvas)

    drawOneGraphBegin(canvas)
    setAlpha(canvas, 1)
    setStrokeCap(canvas, CAP_BUTT)
    setStrokeJoin(canvas, JOIN_MITER)
    setStrokeWidth(canvas, 1.5)
    color = LColor:new(1, 0, 0, 0)
    setStrokeColor(canvas, color)
    effect = {2.5, 2.5}
    setDashEffect(canvas, 2, effect)
    rightV = -37 + contentWidth
    bottomV = -10.5 + contentHeight
    rect = LRect:new(6, 6, rightV, bottomV)
    drawStrokeRoundRect(canvas, rect, 12.5)
    drawOneGraphEnd(canvas)

    drawOneGraphBegin(canvas)
    setAlpha(canvas, 1)
    leftV = -54.00000000010641 + contentWidth
    rightV = -1.064108801074326e-10 + contentWidth
    bottomV = 0 + contentHeight
    rect = LRect:new(leftV, bottomV - 57, rightV, bottomV)
    drawBitmap(canvas, "star.png", rect)
    drawOneGraphEnd(canvas)

end




