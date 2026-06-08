
function SalesBuildingMap({
  floorData,
  selectedRooms,
  setSelectedRooms
}) {

  if (!floorData?.length) {

    return (
      <div
        style={{
          flex: 1,

          background: '#fff',

          border:
            '1px solid var(--outline-variant)',

          borderRadius: '16px',

          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',

          color: '#94a3b8',

          fontSize: '14px',

          fontWeight: '500'
        }}
      >
        동을 선택해주세요.
      </div>
    );
  }

  const handleRoomClick = (
    room
  ) => {

    if (room.status === 'DISABLED') {
      return;
    }

    const exists =
      selectedRooms.some(
        item => item.ho === room.ho
      );

    if (exists) {

      setSelectedRooms(

        selectedRooms.filter(
          item => item.ho !== room.ho
        )

      );

    } else {

      setSelectedRooms([
        ...selectedRooms,

        {
          ho: room.ho
        }
      ]);
    }
  };

  return (
    <div
      style={{
        flex: 1,
        background: '#fff',
        border: '1px solid var(--outline-variant)',
        borderRadius: '16px',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column'
      }}
    >

      {/* 상단 */}
      <div
        style={{
          padding: '14px 20px',
          borderBottom: '1px solid #eee',
          display: 'flex',
          gap: '14px',
          flexWrap: 'wrap'
        }}
      >

        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '6px',
            fontSize: '12px'
          }}
        >
          <div
            style={{
              width: '12px',
              height: '12px',
              borderRadius: '4px',
              background: '#ecfdf5',
              border: '1px solid #86efac'
            }}
          />
          공실
        </div>

        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '6px',
            fontSize: '12px'
          }}
        >
          <div
            style={{
              width: '12px',
              height: '12px',
              borderRadius: '4px',
              background: '#fef2f2',
              border: '1px solid #fca5a5'
            }}
          />
          거주중
        </div>

        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '6px',
            fontSize: '12px'
          }}
        >
          <div
            style={{
              width: '12px',
              height: '12px',
              borderRadius: '4px',
              background: '#f3f4f6',
              border: '1px solid #d1d5db'
            }}
          />
          사용불가
        </div>

      </div>
      {/* 배치도 */}
      <div
        style={{
          padding: '14px',
          overflowY: 'auto',
          flex: 1
        }}
      >

        {floorData.map((floorObj) => (

          <div
            key={floorObj.floor}
            style={{
              display: 'flex',
              alignItems: 'center',
              alignItems: 'flex-start',
              marginBottom: '8px'
            }}
          >

            {/* 층 */}
            <div
              style={{
                width: '42px',
                flexShrink: 0,
                fontSize: '12px',
                fontWeight: '700'
              }}
            >
              {floorObj.floor}
            </div>

            {/* 호 */}
            <div
              style={{
                display: 'grid',

                gridTemplateColumns:
                  'repeat(auto-fill, minmax(54px, 1fr))',

                gap: '6px',

                width: '100%'
              }}
            >

              {floorObj.rooms.map((room) => {

                const isSelected =
                  selectedRooms.some(
                    item => item.ho === room.ho
                  );

                return (
                  <button
                    key={room.ho}
                    onClick={() => handleRoomClick(room)}
                    style={{
                      height: '28px',
                      minWidth: '54px',
                      padding: '0 10px',

                      borderRadius: '8px',
                      border: isSelected
                        ? '1px solid #2563eb'
                        : room.status === 'LIVE'
                          ? '1px solid #fca5a5'
                          : room.status === 'DISABLED'
                            ? '1px solid #d1d5db'
                            : '1px solid #86efac',

                      background: isSelected
                        ? '#dbeafe'
                        : room.status === 'LIVE'
                          ? '#fef2f2'
                          : room.status === 'DISABLED'
                            ? '#f3f4f6'
                            : '#ecfdf5',

                      color: isSelected
                        ? '#1d4ed8'
                        : room.status === 'LIVE'
                          ? '#dc2626'
                          : room.status === 'DISABLED'
                            ? '#6b7280'
                            : '#15803d',

                      fontWeight: '600',
                      fontSize: '11px',

                      cursor:
                        room.status === 'DISABLED'
                          ? 'not-allowed'
                          : 'pointer'
                    }}
                  >
                    {room.ho}
                  </button>
                );
              })}

            </div>

          </div>

        ))}

      </div>

    </div>
  );
}

export default SalesBuildingMap;